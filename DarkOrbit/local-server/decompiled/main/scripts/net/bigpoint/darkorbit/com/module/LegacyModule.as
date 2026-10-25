package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LegacyModule implements IModule
   {
      
      private static var _instance:LegacyModule;
      
      public var message:String = "";
      
      public function LegacyModule(param1:String = "")
      {
         super();
         this.message = param1;
      }
      
      public static function get instance() : LegacyModule
      {
         return _instance || (_instance = new LegacyModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 1;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.message = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(1);
         param1.writeUTF(this.message);
      }
   }
}

