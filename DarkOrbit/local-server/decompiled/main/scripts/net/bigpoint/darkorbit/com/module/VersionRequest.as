package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class VersionRequest implements IModule
   {
      
      private static var _instance:VersionRequest;
      
      public var version:String = "";
      
      public function VersionRequest(param1:String = "")
      {
         super();
         this.version = param1;
      }
      
      public static function get instance() : VersionRequest
      {
         return _instance || (_instance = new VersionRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 666;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.version = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(666);
         param1.writeUTF(this.version);
      }
   }
}

