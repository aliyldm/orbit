package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TrainingArenaRankInfoCommand implements IModule
   {
      
      private static var _instance:TrainingArenaRankInfoCommand;
      
      public var points:Number = 0;
      
      public var rank:int = 0;
      
      public var battles:int = 0;
      
      public var victories:int = 0;
      
      public function TrainingArenaRankInfoCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:Number = 0)
      {
         super();
         this.points = param4;
         this.rank = param3;
         this.battles = param2;
         this.victories = param1;
      }
      
      public static function get instance() : TrainingArenaRankInfoCommand
      {
         return _instance || (_instance = new TrainingArenaRankInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -8718;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.points = param1.readFloat();
         this.rank = param1.readInt();
         this.rank = this.rank >>> 12 % 32 | this.rank << 32 - 12 % 32;
         this.battles = param1.readInt();
         this.battles = this.battles << 11 % 32 | this.battles >>> 32 - 11 % 32;
         this.victories = param1.readInt();
         this.victories = this.victories << 12 % 32 | this.victories >>> 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-8718);
         param1.writeFloat(this.points);
         param1.writeInt(this.rank << 12 % 32 | this.rank >>> 32 - 12 % 32);
         param1.writeInt(this.battles >>> 11 % 32 | this.battles << 32 - 11 % 32);
         param1.writeInt(this.victories >>> 12 % 32 | this.victories << 32 - 12 % 32);
      }
   }
}

