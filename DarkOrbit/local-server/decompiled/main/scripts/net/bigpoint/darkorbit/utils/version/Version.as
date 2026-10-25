package net.bigpoint.darkorbit.utils.version
{
   public class Version
   {
      
      public static const VERSION:String = "10.0";
      
      public static const BUILD:String = "23462228";
      
      private var _version:String = "10.0";
      
      public function Version()
      {
         super();
         if(BUILD != "%" + "BUILD.NUMBER" + "%")
         {
            this._version += "." + BUILD;
         }
         var _loc1_:String = "";
         this._version += _loc1_;
      }
      
      public function getVersion() : String
      {
         return this._version;
      }
   }
}

