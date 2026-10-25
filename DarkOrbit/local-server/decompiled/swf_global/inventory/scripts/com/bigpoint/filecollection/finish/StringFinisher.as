package com.bigpoint.filecollection.finish
{
   public class StringFinisher extends FileCollectionFinisher
   {
      
      public function StringFinisher()
      {
         super();
      }
      
      public function getString() : String
      {
         return _data;
      }
   }
}

