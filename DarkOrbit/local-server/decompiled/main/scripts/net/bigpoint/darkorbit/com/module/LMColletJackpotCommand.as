package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LMColletJackpotCommand implements IModule
   {
      
      private static var _instance:LMColletJackpotCommand;
      
      public var priorityMode:LogMessengerPriorityModule;
      
      public var collectedAmount:Number = 0;
      
      public var summedAmmount:Number = 0;
      
      public function LMColletJackpotCommand(param1:LogMessengerPriorityModule = null, param2:Number = 0, param3:Number = 0)
      {
         super();
         if(param1 == null)
         {
            this.priorityMode = new LogMessengerPriorityModule();
         }
         else
         {
            this.priorityMode = param1;
         }
         this.collectedAmount = param2;
         this.summedAmmount = param3;
      }
      
      public static function get instance() : LMColletJackpotCommand
      {
         return _instance || (_instance = new LMColletJackpotCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 204;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.priorityMode = LogMessengerPriorityModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.priorityMode)
         {
            this.priorityMode.read(param1);
         }
         this.collectedAmount = param1.readFloat();
         this.summedAmmount = param1.readFloat();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(204);
         if(null != this.priorityMode)
         {
            this.priorityMode.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeFloat(this.collectedAmount);
         param1.writeFloat(this.summedAmmount);
      }
   }
}

