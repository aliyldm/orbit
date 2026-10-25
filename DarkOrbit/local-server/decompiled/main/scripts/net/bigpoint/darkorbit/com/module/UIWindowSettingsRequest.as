package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UIWindowSettingsRequest implements IModule
   {
      
      private static var _instance:UIWindowSettingsRequest;
      
      public var windowSettings:Vector.<UIWindowSettingModule>;
      
      public function UIWindowSettingsRequest(param1:Vector.<UIWindowSettingModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.windowSettings = new Vector.<UIWindowSettingModule>();
         }
         else
         {
            this.windowSettings = param1;
         }
      }
      
      public static function get instance() : UIWindowSettingsRequest
      {
         return _instance || (_instance = new UIWindowSettingsRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 341;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:UIWindowSettingModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.windowSettings.length > 0)
         {
            this.windowSettings.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = UIWindowSettingModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.windowSettings.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:UIWindowSettingModule = null;
         param1.writeShort(341);
         param1.writeByte(this.windowSettings.length);
         for each(_loc2_ in this.windowSettings)
         {
            _loc2_.write(param1);
         }
      }
   }
}

