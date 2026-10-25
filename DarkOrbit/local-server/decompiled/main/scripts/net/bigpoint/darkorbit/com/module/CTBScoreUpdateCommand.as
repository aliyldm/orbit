package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CTBScoreUpdateCommand implements IModule
   {
      
      private static var _instance:CTBScoreUpdateCommand;
      
      public var score_MMO:int = 0;
      
      public var score_EIC:int = 0;
      
      public var score_VRU:int = 0;
      
      public function CTBScoreUpdateCommand(param1:int = 0, param2:int = 0, param3:int = 0)
      {
         super();
         this.score_MMO = param1;
         this.score_EIC = param2;
         this.score_VRU = param3;
      }
      
      public static function get instance() : CTBScoreUpdateCommand
      {
         return _instance || (_instance = new CTBScoreUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 218;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.score_MMO = param1.readInt();
         this.score_MMO = this.score_MMO >>> 3 % 32 | this.score_MMO << 32 - 3 % 32;
         this.score_EIC = param1.readInt();
         this.score_EIC = this.score_EIC << 14 % 32 | this.score_EIC >>> 32 - 14 % 32;
         this.score_VRU = param1.readInt();
         this.score_VRU = this.score_VRU << 12 % 32 | this.score_VRU >>> 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(218);
         param1.writeInt(this.score_MMO << 3 % 32 | this.score_MMO >>> 32 - 3 % 32);
         param1.writeInt(this.score_EIC >>> 14 % 32 | this.score_EIC << 32 - 14 % 32);
         param1.writeInt(this.score_VRU >>> 12 % 32 | this.score_VRU << 32 - 12 % 32);
      }
   }
}

