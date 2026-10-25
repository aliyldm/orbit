package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LMGGEnergyCollectedCommand implements IModule
   {
      
      private static var _instance:LMGGEnergyCollectedCommand;
      
      public var priorityMode:LogMessengerPriorityModule;
      
      public function LMGGEnergyCollectedCommand(param1:LogMessengerPriorityModule = null)
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
      }
      
      public static function get instance() : LMGGEnergyCollectedCommand
      {
         return _instance || (_instance = new LMGGEnergyCollectedCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 212;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.priorityMode = LogMessengerPriorityModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.priorityMode)
         {
            this.priorityMode.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(212);
         if(null != this.priorityMode)
         {
            this.priorityMode.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

