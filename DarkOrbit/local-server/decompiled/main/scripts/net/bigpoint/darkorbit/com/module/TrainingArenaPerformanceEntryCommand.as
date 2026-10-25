package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TrainingArenaPerformanceEntryCommand implements IModule
   {
      
      private static var _instance:TrainingArenaPerformanceEntryCommand;
      
      public var seasonName:String = "";
      
      public var rank:int = 0;
      
      public function TrainingArenaPerformanceEntryCommand(param1:String = "", param2:int = 0)
      {
         super();
         this.seasonName = param1;
         this.rank = param2;
      }
      
      public static function get instance() : TrainingArenaPerformanceEntryCommand
      {
         return _instance || (_instance = new TrainingArenaPerformanceEntryCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 27700;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.seasonName = param1.readUTF();
         this.rank = param1.readInt();
         this.rank = this.rank >>> 3 % 32 | this.rank << 32 - 3 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(27700);
         param1.writeUTF(this.seasonName);
         param1.writeInt(this.rank << 3 % 32 | this.rank >>> 32 - 3 % 32);
      }
   }
}

