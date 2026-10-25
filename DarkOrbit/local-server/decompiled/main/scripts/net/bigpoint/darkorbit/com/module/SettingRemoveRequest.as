package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SettingRemoveRequest implements IModule
   {
      
      private static var _instance:SettingRemoveRequest;
      
      public var key:String = "";
      
      public var immediately:Boolean = false;
      
      public function SettingRemoveRequest(param1:String = "", param2:Boolean = false)
      {
         super();
         this.key = param1;
         this.immediately = param2;
      }
      
      public static function get instance() : SettingRemoveRequest
      {
         return _instance || (_instance = new SettingRemoveRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 87;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 3;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.key = param1.readUTF();
         this.immediately = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(87);
         param1.writeUTF(this.key);
         param1.writeBoolean(this.immediately);
      }
   }
}

