package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestCancelledCommand implements IModule
   {
      
      private static var _instance:QuestCancelledCommand;
      
      public var id:int = 0;
      
      public function QuestCancelledCommand(param1:int = 0)
      {
         super();
         this.id = param1;
      }
      
      public static function get instance() : QuestCancelledCommand
      {
         return _instance || (_instance = new QuestCancelledCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2006;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.id = param1.readInt();
         this.id = this.id << 1 % 32 | this.id >>> 32 - 1 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(2006);
         param1.writeInt(this.id >>> 1 % 32 | this.id << 32 - 1 % 32);
      }
   }
}

