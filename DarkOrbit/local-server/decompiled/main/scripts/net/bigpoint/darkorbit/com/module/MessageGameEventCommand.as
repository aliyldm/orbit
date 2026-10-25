package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MessageGameEventCommand implements IModule
   {
      
      private static var _instance:MessageGameEventCommand;
      
      public var messageKey:String = "";
      
      public var wildCard:String = "";
      
      public var replacementValue:String = "";
      
      public function MessageGameEventCommand(param1:String = "", param2:String = "", param3:String = "")
      {
         super();
         this.messageKey = param1;
         this.wildCard = param2;
         this.replacementValue = param3;
      }
      
      public static function get instance() : MessageGameEventCommand
      {
         return _instance || (_instance = new MessageGameEventCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 176;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.messageKey = param1.readUTF();
         this.wildCard = param1.readUTF();
         this.replacementValue = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(176);
         param1.writeUTF(this.messageKey);
         param1.writeUTF(this.wildCard);
         param1.writeUTF(this.replacementValue);
      }
   }
}

