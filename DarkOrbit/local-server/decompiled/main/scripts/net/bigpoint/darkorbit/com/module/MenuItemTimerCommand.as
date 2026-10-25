package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MenuItemTimerCommand implements IModule
   {
      
      private static var _instance:MenuItemTimerCommand;
      
      public var activatable:Boolean = false;
      
      public var timerState:TimerStateModule;
      
      public var menuItemId:String = "";
      
      public var maxTime:Number = 0;
      
      public var time:Number = 0;
      
      public function MenuItemTimerCommand(param1:String = "", param2:TimerStateModule = null, param3:Number = 0, param4:Number = 0, param5:Boolean = false)
      {
         super();
         this.activatable = param5;
         if(param2 == null)
         {
            this.timerState = new TimerStateModule();
         }
         else
         {
            this.timerState = param2;
         }
         this.menuItemId = param1;
         this.maxTime = param4;
         this.time = param3;
      }
      
      public static function get instance() : MenuItemTimerCommand
      {
         return _instance || (_instance = new MenuItemTimerCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -12955;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 19;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.activatable = param1.readBoolean();
         this.timerState = TimerStateModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.timerState)
         {
            this.timerState.read(param1);
         }
         this.menuItemId = param1.readUTF();
         this.maxTime = param1.readDouble();
         this.time = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-12955);
         param1.writeBoolean(this.activatable);
         if(null != this.timerState)
         {
            this.timerState.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeUTF(this.menuItemId);
         param1.writeDouble(this.maxTime);
         param1.writeDouble(this.time);
      }
   }
}

