package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class InvasionEventInitCommand implements IModule
   {
      
      private static var _instance:InvasionEventInitCommand;
      
      public var score_MMO:Number = 0;
      
      public var score_EIC:Number = 0;
      
      public var score_VRU:Number = 0;
      
      public var waveCount:int = 0;
      
      public function InvasionEventInitCommand(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:int = 0)
      {
         super();
         this.score_MMO = param1;
         this.score_EIC = param2;
         this.score_VRU = param3;
         this.waveCount = param4;
      }
      
      public static function get instance() : InvasionEventInitCommand
      {
         return _instance || (_instance = new InvasionEventInitCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 223;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 28;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.score_MMO = param1.readDouble();
         this.score_EIC = param1.readDouble();
         this.score_VRU = param1.readDouble();
         this.waveCount = param1.readInt();
         this.waveCount = this.waveCount >>> 10 % 32 | this.waveCount << 32 - 10 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(223);
         param1.writeDouble(this.score_MMO);
         param1.writeDouble(this.score_EIC);
         param1.writeDouble(this.score_VRU);
         param1.writeInt(this.waveCount << 10 % 32 | this.waveCount >>> 32 - 10 % 32);
      }
   }
}

