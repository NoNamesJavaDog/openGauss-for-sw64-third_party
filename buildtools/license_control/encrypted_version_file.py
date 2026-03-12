#!/usr/bin/env python
# -*- coding:utf-8 -*-


import os
import sys
import base64
import struct
import binascii


try:
    from typing import List
except ImportError:
    List = list


# Feature list file.
PRODUCT_FEATURE_FILE = "GaussDB_features_list"
# Gauss version file.
VERSION_FILE = "gaussdb.version"
LICENSE_FILE = "gaussdb.license"
# Product version.
PRODUCT_VERSION_GAUSS200 = "GaussDB200"
PRODUCT_VERSION_GAUSS300 = "GaussDB300"
LICENSE_VERSION_GAUSS200_STANDARD = "GaussDB200_Standard"


def read_disabled_feature_list():
    """
    Read the disabled feature list of Gauss DB.

    The directory of the feature list file is at the same level as the binary file and script directory.
    Feature information is stored in the file line by line, such as:
        Feature_Class Feature Gauss200_Whether_To_Support Gauss300_Whether_To_Support
        ...

    Disabled feature information will be translated as a dictionary, such as:
        {
            "Gauss200" : [ "Feature" ],
            "Gauss300" : [ "Feature" ]
        }

    :return:    According to the specified Gauss DB version, return the corresponding list of disabled feature id.
                If the feature list file does not exist, return None.
    :rtype:     dict | None
    """
    sys.stdout.write("Start read the Gauss DB feature list.\n")

    # Get the feature list file path.
    feature_file = os.path.join(os.path.dirname(__file__), PRODUCT_FEATURE_FILE)
    sys.stdout.write("The feature list file path is %s.\n" % feature_file)
    if not os.path.exists(feature_file):
        raise NameError("Gauss DB feature file does not exist, skip this operation.\n")
    elif not os.path.isfile(feature_file):
        raise NameError("Gauss DB feature file is not a file, skip this operation.\n")

    # Change file permission.
    os.chmod(feature_file, 0o600)
    sys.stdout.write("Change the permission of the file (%s) to %o.\n" % (feature_file, 0o600))

    # Load the feature list.
    with open(feature_file, "r") as fp:
        lines = fp.readlines()  # type: List[str]

    feature_list = {PRODUCT_VERSION_GAUSS200: [], PRODUCT_VERSION_GAUSS300: [], LICENSE_VERSION_GAUSS200_STANDARD: []}
    if lines:
        for line in lines:
            items = __read_items_from_line(line)
            if items is None or len(items) == 0:
                continue

            if len(items) != 6:
                raise ValueError("Error content %s of file %s.\n" % (line, feature_file))

            feature_id, _, _, support_200, support_300, support_200_standard = items

            feature_id = int(feature_id)
            support_200 = support_200.lower()
            support_300 = support_300.lower()
            support_200_standard = support_200_standard.lower()

            if support_200 == "no":
                feature_list[PRODUCT_VERSION_GAUSS200].append(feature_id)
            elif support_200 != "yes":
                sys.stdout.write("Error content %s of file %s.\n" % (line, feature_file))
                return None

            if support_300 == "no":
                feature_list[PRODUCT_VERSION_GAUSS300].append(feature_id)
            elif support_300 != "yes":
                sys.stdout.write("Error content %s of file %s.\n" % (line, feature_file))
                return None

            if support_200_standard == "no":
                feature_list[LICENSE_VERSION_GAUSS200_STANDARD].append(feature_id)
    else:
        sys.stdout.write("The feature list file (%s) is exist, but is empty.\n" % feature_file)

    return feature_list


def __read_items_from_line(line, sep=" "):
    """
    Split the list of items from a row of data and remove empty items.

    :param line:    the string which need to be split.
    :param sep:     Separator of the string.

    :type line:     str
    :type sep:      str

    :return:        Returns a list of split string.
    :rtype:         List[int, str, str, str, str]
    """
    if not line:
        return []

    return [l.strip() for l in line.split(sep) if l and l.strip()]


def encrypted_feature_info(disabled_features, product_version, feature_file):
    """
    Convert the disabled feature list of Gauss DB to byte stream data and save it to the specified file.

    All exceptions of this method are exposed to its caller.

    Finally, The format of the data which was stored in the file are as follows:
        unsigned int crc32_code
        unsigned int encrypted_data_len
        unsigned int unencrypted_data_len
        char [] base64_encode_data
    The data before base64 encryption can be interpreted as:
        unsigned int product_flag.
        unsigned int disabled_features_number
        unsigned short disabled_features[disabled_features_number]

    :param disabled_features:    The disabled feature list of Gauss DB
    :param product_version:      The version information of Gauss DB
    :param feature_file:         Files used to save byte stream.

    :type disabled_features:     list
    :type product_version:       str
    :type feature_file:          str

    :raise ValueError:          If the value of the parameter "productVersion" is incorrect, raise this Exception.
    """
    # Setting product flag according to Gauss DB version.
    if product_version.lower() == PRODUCT_VERSION_GAUSS200.lower():
        product_flag = 2
    elif product_version.lower() == PRODUCT_VERSION_GAUSS300.lower():
        product_flag = 3
    elif product_version.lower() == LICENSE_VERSION_GAUSS200_STANDARD.lower():
        product_flag = 2
    else:
        raise ValueError("Illegal parameter 'product_version' values.")
    # Combine format of "data" field converted to streaming data according to the length of the disabled feature
    #  list.
    data_format = "BI"
    data_format = data_format.ljust(len(data_format) + len(disabled_features), "H")

    # Stream the "data" field.
    data = struct.pack(data_format, product_flag, len(disabled_features), *disabled_features)
    # Base64 encode the "data" field.
    base64_data = base64.b64encode(data)

    # Calculate CRC32 value of the "data" filed which was encoded by base64.
    crc32_code = binascii.crc32(base64_data) & 0xFFFFFFFF
    # The format of "header" field.
    header_format = "III"

    # Stream the "header" field.
    header_data = struct.pack(header_format, crc32_code, len(base64_data), len(data))

    # Save the byte stream data to the specified file.
    with open(feature_file, "wb") as fp:
        fp.write(header_data)
        fp.write(base64_data)


def gen_version_file():
    """
    Generate Gauss 200 and Gauss 300 license control files.
    """
    feature_list = read_disabled_feature_list()

    for product_version in [PRODUCT_VERSION_GAUSS200, PRODUCT_VERSION_GAUSS300]:
        version_file = os.path.join(os.path.dirname(__file__), "%s.%s" % (VERSION_FILE, product_version))
        encrypted_feature_info(feature_list[product_version], product_version, version_file)

    for product_version in [LICENSE_VERSION_GAUSS200_STANDARD]:
        version_file = os.path.join(os.path.dirname(__file__), "%s.%s" % (LICENSE_FILE, product_version))
        encrypted_feature_info(feature_list[product_version], product_version, version_file)


if __name__ == "__main__":
    gen_version_file()
