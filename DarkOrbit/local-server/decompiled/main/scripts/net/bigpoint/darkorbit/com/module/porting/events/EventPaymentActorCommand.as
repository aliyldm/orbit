package net.bigpoint.darkorbit.com.module.porting.events
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EventPaymentActorCommand implements IModule
   {
      
      private static var _instance:EventPaymentActorCommand;
      
      public var special:Boolean = false;
      
      public var secondsUntilEnd:Number = 0;
      
      public var layerImage:String = "";
      
      public var description:String = "";
      
      public var bgImage:String = "";
      
      public var eventName:String = "";
      
      public function EventPaymentActorCommand(param1:String = "", param2:String = "", param3:String = "", param4:String = "", param5:Number = 0, param6:Boolean = false)
      {
         super();
         this.special = param6;
         this.secondsUntilEnd = param5;
         this.layerImage = param2;
         this.description = param4;
         this.bgImage = param1;
         this.eventName = param3;
      }
      
      public static function get instance() : EventPaymentActorCommand
      {
         return _instance || (_instance = new EventPaymentActorCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -3855;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 17;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.special = param1.readBoolean();
         this.secondsUntilEnd = param1.readDouble();
         this.layerImage = param1.readUTF();
         this.description = param1.readUTF();
         this.bgImage = param1.readUTF();
         this.eventName = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-3855);
         param1.writeBoolean(this.special);
         param1.writeDouble(this.secondsUntilEnd);
         param1.writeUTF(this.layerImage);
         param1.writeUTF(this.description);
         param1.writeUTF(this.bgImage);
         param1.writeUTF(this.eventName);
      }
   }
}

