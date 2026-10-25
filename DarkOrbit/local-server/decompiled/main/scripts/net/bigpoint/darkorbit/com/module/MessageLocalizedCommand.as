package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MessageLocalizedCommand implements IModule
   {
      
      private static var _instance:MessageLocalizedCommand;
      
      public var messageKey:String = "";
      
      public function MessageLocalizedCommand(param1:String = "")
      {
         super();
         this.messageKey = param1;
      }
      
      public static function get instance() : MessageLocalizedCommand
      {
         return _instance || (_instance = new MessageLocalizedCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 46;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.messageKey = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(46);
         param1.writeUTF(this.messageKey);
      }
   }
}

