package Infinicast.Runtime
{
   public class APlayStringMessage
   {
      
      public var strData:String;
      
      public var json:Object;
      
      public function APlayStringMessage()
      {
         super();
      }
      
      public function get DataAsString() : String
      {
         if(this.strData != null)
         {
            return this.strData;
         }
         if(this.json != null)
         {
            this.strData = JSON.stringify(this.json);
         }
         return this.strData;
      }
      
      public function set DataAsString(param1:String) : void
      {
         this.strData = param1;
      }
      
      public function get DataAsJson() : Object
      {
         return this.json;
      }
      
      public function set DataAsJson(param1:Object) : void
      {
         this.json = param1;
      }
      
      public function toString() : String
      {
         return this.DataAsString;
      }
   }
}

