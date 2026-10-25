package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestPrivilegeCommand implements IModule
   {
      
      private static var _instance:QuestPrivilegeCommand;
      
      public var questId:int = 0;
      
      public function QuestPrivilegeCommand(param1:int = 0)
      {
         super();
         this.questId = param1;
      }
      
      public static function get instance() : QuestPrivilegeCommand
      {
         return _instance || (_instance = new QuestPrivilegeCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2022;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.questId = param1.readInt();
         this.questId = this.questId >>> 15 % 32 | this.questId << 32 - 15 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(2022);
         param1.writeInt(this.questId << 15 % 32 | this.questId >>> 32 - 15 % 32);
      }
   }
}

