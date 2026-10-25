package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestCompletedCommand implements IModule
   {
      
      private static var _instance:QuestCompletedCommand;
      
      public var id:int = 0;
      
      public var rating:int = 0;
      
      public function QuestCompletedCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.id = param1;
         this.rating = param2;
      }
      
      public static function get instance() : QuestCompletedCommand
      {
         return _instance || (_instance = new QuestCompletedCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2004;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.id = param1.readInt();
         this.id = this.id >>> 2 % 32 | this.id << 32 - 2 % 32;
         this.rating = param1.readInt();
         this.rating = this.rating >>> 13 % 32 | this.rating << 32 - 13 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(2004);
         param1.writeInt(this.id << 2 % 32 | this.id >>> 32 - 2 % 32);
         param1.writeInt(this.rating << 13 % 32 | this.rating >>> 32 - 13 % 32);
      }
   }
}

