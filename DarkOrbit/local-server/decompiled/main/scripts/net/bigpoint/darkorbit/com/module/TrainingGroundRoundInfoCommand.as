package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TrainingGroundRoundInfoCommand implements IModule
   {
      
      private static var _instance:TrainingGroundRoundInfoCommand;
      
      public static const TRAININGGROUNDRONDSTATUSTYPE_STARTED:int = 0;
      
      public static const TRAININGGROUNDRONDSTATUSTYPE_FINISHED:int = 1;
      
      public static const TRAININGGROUNDRONDSTATUSTYPE__MAX:int = 2;
      
      public var statusType:int = 0;
      
      public var roundIndex:int = 0;
      
      public function TrainingGroundRoundInfoCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.statusType = param2;
         this.roundIndex = param1;
      }
      
      public static function get instance() : TrainingGroundRoundInfoCommand
      {
         return _instance || (_instance = new TrainingGroundRoundInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -1923;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.statusType = param1.readShort();
         this.roundIndex = param1.readInt();
         this.roundIndex = this.roundIndex >>> 12 % 32 | this.roundIndex << 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-1923);
         param1.writeShort(this.statusType);
         param1.writeInt(this.roundIndex << 12 % 32 | this.roundIndex >>> 32 - 12 % 32);
      }
   }
}

