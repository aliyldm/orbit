package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestFailedCommand implements IModule
   {
      
      private static var _instance:QuestFailedCommand;
      
      public var id:int = 0;
      
      public function QuestFailedCommand(param1:int = 0)
      {
         super();
         this.id = param1;
      }
      
      public static function get instance() : QuestFailedCommand
      {
         return _instance || (_instance = new QuestFailedCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2005;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.id = param1.readInt();
         this.id = this.id >>> 5 % 32 | this.id << 32 - 5 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(2005);
         param1.writeInt(this.id << 5 % 32 | this.id >>> 32 - 5 % 32);
      }
   }
}

