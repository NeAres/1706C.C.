# 1706C.C.
This is a project dedicated to provide photo scanning service

There are 4 parts (or 5 parts) in this project

\----------------------First Part: Cut & Paste------------------------\

This part serves for cutting the source image out of the original image.
When running the app, fill your folder with image fulfilled, then rename it to "B", and drag to iTunes File Sharing.
Hint: you can alter the origin and error by setting the values in "Helper.swift"

\----------------------------------------------------------------------\


\-------------------------Second Part: Solemn-----------------------------\

This part is used to cut a whole piece of image, and it is usually used to process datas transferred from one people or entity to another
For example, number 23 wants to send a message to 25, then we should put the image made by 23 to the folder named 23, then rename the image to 25
(For the convenience of the fourth part)

\--------------------------------------------------------------------------\


\--------------------------------Third/Fourth Part: PDF Maker----------------------------------\

Although it is named PDFMaker, the real step of making pdf is the Fifth part
The third part is process the content of customize the theme, including adding the blank content
The fourth part is add all writing content to the image and make a new one. There shall be four folders in the itunes file sharing
    -SelfDefine: The source image of customize theme, those subfolder is named with the number of the specified individual, beginning with 00 and end with (subfolder.content.count)
    -SpecialCare: folder(s) processed in the 2nd part
    -CommonCon: folders processed in the 1st part
    -Theme: Theme file made by me, you can customize in the "classes.plist" in the file
Output folder: SavedContent

\---------------------------------------------------------------------------------------------\


\------------------------------Fifth part: Complimentry----------------------------------------\

This part has only one function: Create PDF file
Three folders are required
    -SelfDefine
    -Theme
    -Data: images processed by the "PDF Maker" (SavedContent renamed)
    
\-----------------------------------------------------------------------------------------------\

If you have any question, please contact 603092145@qq.com
