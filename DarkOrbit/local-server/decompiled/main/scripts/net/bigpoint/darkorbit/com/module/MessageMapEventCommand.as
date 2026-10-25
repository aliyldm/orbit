package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MessageMapEventCommand implements IModule
   {
      
      private static var _instance:MessageMapEventCommand;
      
      public static const MESSAGETYPE_STANDARD:int = 0;
      
      public static const MESSAGETYPE__MAX:int = 1;
      
      public var type:int = 0;
      
      public var priority:int = 0;
      
      public var message:String = "";
      
      public var replacementObjectList:Vector.<String>;
      
      public function MessageMapEventCommand(param1:int = 0, param2:int = 0, param3:String = "", param4:Vector.<String> = null)
      {
         super();
         this.type = param1;
         this.priority = param2;
         this.message = param3;
         if(param4 == null)
         {
            this.replacementObjectList = new Vector.<String>();
         }
         else
         {
            this.replacementObjectList = param4;
         }
      }
      
      public static function get instance() : MessageMapEventCommand
      {
         return _instance || (_instance = new MessageMapEventCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 174;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.type = param1.readShort();
         this.priority = param1.readInt();
         this.priority = this.priority << 11 % 32 | this.priority >>> 32 - 11 % 32;
         this.message = param1.readUTF();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.replacementObjectList.length > 0)
         {
            this.replacementObjectList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.replacementObjectList.push(param1.readUTF());
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:String = null;
         param1.writeShort(174);
         param1.writeShort(this.type);
         param1.writeInt(this.priority >>> 11 % 32 | this.priority << 32 - 11 % 32);
         param1.writeUTF(this.message);
         param1.writeByte(this.replacementObjectList.length);
         for each(_loc2_ in this.replacementObjectList)
         {
            param1.writeUTF(_loc2_);
         }
      }
   }
}

