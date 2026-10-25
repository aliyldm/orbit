package net.bigpoint.darkorbit.com.module.porting.logbook
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LogbookDataCommand implements IModule
   {
      
      private static var _instance:LogbookDataCommand;
      
      public var quest:int = 0;
      
      public var info:String = "";
      
      public var args:String = "";
      
      public var count:int = 0;
      
      public var insertDate:String = "";
      
      public var questDone:int = 0;
      
      public var infoText:String = "";
      
      public function LogbookDataCommand(param1:String = "", param2:String = "", param3:int = 0, param4:int = 0, param5:int = 0, param6:String = "", param7:String = "")
      {
         super();
         this.quest = param4;
         this.info = param2;
         this.args = param7;
         this.count = param3;
         this.insertDate = param6;
         this.questDone = param5;
         this.infoText = param1;
      }
      
      public static function get instance() : LogbookDataCommand
      {
         return _instance || (_instance = new LogbookDataCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 20059;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 20;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.quest = param1.readInt();
         this.quest = this.quest << 5 % 32 | this.quest >>> 32 - 5 % 32;
         this.info = param1.readUTF();
         this.args = param1.readUTF();
         this.count = param1.readInt();
         this.count = this.count << 12 % 32 | this.count >>> 32 - 12 % 32;
         this.insertDate = param1.readUTF();
         this.questDone = param1.readInt();
         this.questDone = this.questDone >>> 15 % 32 | this.questDone << 32 - 15 % 32;
         this.infoText = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(20059);
         param1.writeInt(this.quest >>> 5 % 32 | this.quest << 32 - 5 % 32);
         param1.writeUTF(this.info);
         param1.writeUTF(this.args);
         param1.writeInt(this.count >>> 12 % 32 | this.count << 32 - 12 % 32);
         param1.writeUTF(this.insertDate);
         param1.writeInt(this.questDone << 15 % 32 | this.questDone >>> 32 - 15 % 32);
         param1.writeUTF(this.infoText);
      }
   }
}

