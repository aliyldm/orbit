package net.bigpoint.darkorbit.com.module.porting.events
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class SpecialEventPaymentActorCommand implements IModule
   {
      
      private static var _instance:SpecialEventPaymentActorCommand;
      
      public var eventType:String = "";
      
      public var command:EventPaymentActorCommand;
      
      public function SpecialEventPaymentActorCommand(param1:String = "", param2:EventPaymentActorCommand = null)
      {
         super();
         this.eventType = param1;
         if(param2 == null)
         {
            this.command = new EventPaymentActorCommand();
         }
         else
         {
            this.command = param2;
         }
      }
      
      public static function get instance() : SpecialEventPaymentActorCommand
      {
         return _instance || (_instance = new SpecialEventPaymentActorCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 331;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.eventType = param1.readUTF();
         this.command = EventPaymentActorCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.command)
         {
            this.command.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(331);
         param1.writeUTF(this.eventType);
         if(null != this.command)
         {
            this.command.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

