package Infinicast.Client.Impl
{
   import Infinicast.Runtime.LanguageVersion;
   
   public class VersionHelper
   {
      
      public function VersionHelper()
      {
         super();
      }
      
      public static function get clientVersion() : String
      {
         return "v1.03.06" + LanguageVersion.Version;
      }
   }
}

