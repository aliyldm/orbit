package com.bigpoint.filecollection.finish
{
   public class XMLFinisher extends FileCollectionFinisher
   {
      
      public function XMLFinisher()
      {
         super();
      }
      
      public function getXML() : XML
      {
         try
         {
            return new XML(_data);
         }
         catch(e:Error)
         {
         }
         return null;
      }
   }
}

