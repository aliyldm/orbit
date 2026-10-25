package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MenuItemCooldownGroupTimerCommand implements IModule
   {
      
      private static var _instance:MenuItemCooldownGroupTimerCommand;
      
      public var timerState:TimerStateModule;
      
      public var cooldownType:CooldownTypeModule;
      
      public var maxTime:Number = 0;
      
      public var time:Number = 0;
      
      public function MenuItemCooldownGroupTimerCommand(param1:CooldownTypeModule = null, param2:TimerStateModule = null, param3:Number = 0, param4:Number = 0)
      {
         super();
         if(param2 == null)
         {
            this.timerState = new TimerStateModule();
         }
         else
         {
            this.timerState = param2;
         }
         if(param1 == null)
         {
            this.cooldownType = new CooldownTypeModule();
         }
         else
         {
            this.cooldownType = param1;
         }
         this.maxTime = param4;
         this.time = param3;
      }
      
      public static function get instance() : MenuItemCooldownGroupTimerCommand
      {
         return _instance || (_instance = new MenuItemCooldownGroupTimerCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 31268;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.timerState = TimerStateModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.timerState)
         {
            this.timerState.read(param1);
         }
         this.cooldownType = CooldownTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.cooldownType)
         {
            this.cooldownType.read(param1);
         }
         this.maxTime = param1.readDouble();
         this.time = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(31268);
         if(null != this.timerState)
         {
            this.timerState.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.cooldownType)
         {
            this.cooldownType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeDouble(this.maxTime);
         param1.writeDouble(this.time);
      }
   }
}

