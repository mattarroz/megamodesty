CellProfiler Pipeline: http://www.cellprofiler.org
Version:1
SVNRevision:11710

LoadImages:[module_num:1|svn_version:\'11587\'|variable_revision_number:11|show_window:True|notes:\x5B\x5D]
    File type to be loaded:individual images
    File selection method:Text-Regular expressions
    Number of images in each group?:3
    Type the text that the excluded images have in common:Do not use
    Analyze all subfolders within the selected folder?:None
    Input image file location:Default Input Folder\x7CNone
    Check image sets for missing or duplicate files?:Yes
    Group images by metadata?:No
    Exclude certain files?:No
    Specify metadata fields to group by:
    Select subfolders to analyze:
    Image count:1
    Text that these images have in common (case-sensitive):.*C001.*.tif
    Position of this image in each group:1
    Extract metadata from where?:None
    Regular expression that finds metadata in the file name:^(?P<Plate>.*)_(?P<Well>\x5BA-P\x5D\x5B0-9\x5D{2})_s(?P<Site>\x5B0-9\x5D)
    Type the regular expression that finds metadata in the subfolder path:.*\x5B\\\\/\x5D(?P<Date>.*)\x5B\\\\/\x5D(?P<Run>.*)$
    Channel count:1
    Group the movie frames?:No
    Grouping method:Interleaved
    Number of channels per group:3
    Load the input as images or objects?:Images
    Name this loaded image:autofocus
    Name this loaded object:Nuclei
    Retain outlines of loaded objects?:No
    Name the outline image:LoadedImageOutlines
    Channel number:1
    Rescale intensities?:No

EnhanceEdges:[module_num:2|svn_version:\'10300\'|variable_revision_number:2|show_window:True|notes:\x5B\x5D]
    Select the input image:autofocus
    Name the output image:EdgedImage
    Automatically calculate the threshold?:Yes
    Absolute threshold:0.2
    Threshold adjustment factor:1
    Select an edge-finding method:Sobel
    Select edge direction to enhance:All
    Calculate Gaussian\'s sigma automatically?:Yes
    Gaussian\'s sigma value:10
    Calculate value for low threshold automatically?:Yes
    Low threshold value:0.1

MeasureImageQuality:[module_num:3|svn_version:\'11705\'|variable_revision_number:4|show_window:True|notes:\x5B\x5D]
    Calculate metrics for which images?:Select...
    Image count:1
    Scale count:1
    Threshold count:1
    Select the images to measure:EdgedImage
    Include the image rescaling value?:No
    Calculate blur metrics?:No
    Spatial scale for blur measurements:20
    Calculate saturation metrics?:No
    Calculate intensity metrics?:Yes
    Calculate thresholds?:No
    Use all thresholding methods?:No
    Select a thresholding method:Otsu Global
    Typical fraction of the image covered by objects:0.1
    Two-class or three-class thresholding?:Two classes
    Minimize the weighted variance or the entropy?:Weighted variance
    Assign pixels in the middle intensity class to the foreground or the background?:Foreground

CalculateMath:[module_num:4|svn_version:\'10905\'|variable_revision_number:1|show_window:True|notes:\x5B\x5D]
    Name the output measurement:Normalized Variance
    Operation:Divide
    Select the numerator measurement type:Image
    Select the numerator objects:None
    Select the numerator measurement:ImageQuality_StdIntensity_EdgedImage
    Multiply the above operand by:1
    Raise the power of above operand by:2
    Select the denominator measurement type:Image
    Select the denominator objects:None
    Select the denominator measurement:ImageQuality_MeanIntensity_EdgedImage
    Multiply the above operand by:1
    Raise the power of above operand by:1
    Take log10 of result?:No
    Multiply the result by:1
    Raise the power of result by:1

ExportToSpreadsheet:[module_num:5|svn_version:\'10880\'|variable_revision_number:7|show_window:True|notes:\x5B\x5D]
    Select or enter the column delimiter:Comma (",")
    Prepend the output file name to the data file names?:No
    Add image metadata columns to your object data file?:No
    Limit output to a size that is allowed in Excel?:No
    Select the columns of measurements to export?:Yes
    Calculate the per-image mean values for object measurements?:No
    Calculate the per-image median values for object measurements?:No
    Calculate the per-image standard deviation values for object measurements?:No
    Output file location:Default Output Folder\x7CNone
    Create a GenePattern GCT file?:No
    Select source of sample row name:Metadata
    Select the image to use as the identifier:None
    Select the metadata to use as the identifier:None
    Export all measurements, using default file names?:No
    Press button to select measurements to export:Image\x7CFileName_autofocus,Image\x7CMath_Normalized Variance
    Data to export:Image
    Combine these object measurements with those of the previous object?:No
    File name:normvar.csv
    Use the object name for the file name?:No
