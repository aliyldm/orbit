package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SettingSetRequest implements IModule
   {
      
      private static var _instance:SettingSetRequest;
      
      public var key:String = "";
      
      public var value:String = "";
      
      public var immediately:Boolean = false;
      
      public function SettingSetRequest(param1:String = "", param2:String = "", param3:Boolean = false)
      {
         super();
         this.key = param1;
         this.value = param2;
         this.immediately = param3;
      }
      
      public static function get instance() : SettingSetRequest
      {
         return _instance || (_instance = new SettingSetRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 84;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.key = param1.readUTF();
         this.value = param1.readUTF();
         this.immediately = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(84);
         param1.writeUTF(this.key);
         param1.writeUTF(this.value);
         param1.writeBoolean(this.immediately);
      }
   }
}

