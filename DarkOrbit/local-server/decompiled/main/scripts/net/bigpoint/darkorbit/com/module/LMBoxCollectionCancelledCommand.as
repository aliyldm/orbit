package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LMBoxCollectionCancelledCommand implements IModule
   {
      
      private static var _instance:LMBoxCollectionCancelledCommand;
      
      public static const REASON_BOX_TOO_BIG:int = 0;
      
      public static const REASON_BOX_ALREADY_COLLECTED:int = 1;
      
      public static const REASON__MAX:int = 2;
      
      public var priorityMode:LogMessengerPriorityModule;
      
      public var reason:int = 0;
      
      public function LMBoxCollectionCancelledCommand(param1:LogMessengerPriorityModule = null, param2:int = 0)
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
         this.reason = param2;
      }
      
      public static function get instance() : LMBoxCollectionCancelledCommand
      {
         return _instance || (_instance = new LMBoxCollectionCancelledCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 216;
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
         this.reason = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(216);
         if(null != this.priorityMode)
         {
            this.priorityMode.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeShort(this.reason);
      }
   }
}

