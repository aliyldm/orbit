package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RerollWindowSettingsModule implements IModule
   {
      
      private static var _instance:RerollWindowSettingsModule;
      
      public var rerollPopupSettings:Boolean = false;
      
      public function RerollWindowSettingsModule(param1:Boolean = false)
      {
         super();
         this.rerollPopupSettings = param1;
      }
      
      public static function get instance() : RerollWindowSettingsModule
      {
         return _instance || (_instance = new RerollWindowSettingsModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -21113;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.rerollPopupSettings = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-21113);
         param1.writeBoolean(this.rerollPopupSettings);
      }
   }
}

