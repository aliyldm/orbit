package com.bigpoint.filecollection.finish
{
   public class JSONFinisher extends FileCollectionFinisher
   {
      
      public function JSONFinisher()
      {
         super();
      }
      
      public function getJSON() : Object
      {
         return JSON.parse(_data);
      }
   }
}

