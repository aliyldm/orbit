package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class DominationFactionInfluenceUpdateCommand extends FactionInfluenceUpdateCommand
   {
      
      private static var _instance:DominationFactionInfluenceUpdateCommand;
      
      public var vruDominationPoints:int = 0;
      
      public var eicDominationPoints:int = 0;
      
      public var mmoDominationPoints:int = 0;
      
      public function DominationFactionInfluenceUpdateCommand(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:int = 0, param5:int = 0, param6:int = 0)
      {
         super(param1,param2,param3);
         this.vruDominationPoints = param6;
         this.eicDominationPoints = param5;
         this.mmoDominationPoints = param4;
      }
      
      public static function get instance() : DominationFactionInfluenceUpdateCommand
      {
         return _instance || (_instance = new DominationFactionInfluenceUpdateCommand());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -21108;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.vruDominationPoints = param1.readInt();
         this.vruDominationPoints = this.vruDominationPoints << 3 % 32 | this.vruDominationPoints >>> 32 - 3 % 32;
         this.eicDominationPoints = param1.readInt();
         this.eicDominationPoints = this.eicDominationPoints >>> 16 % 32 | this.eicDominationPoints << 32 - 16 % 32;
         this.mmoDominationPoints = param1.readInt();
         this.mmoDominationPoints = this.mmoDominationPoints << 7 % 32 | this.mmoDominationPoints >>> 32 - 7 % 32;
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-21108);
         super.write(param1);
         param1.writeInt(this.vruDominationPoints >>> 3 % 32 | this.vruDominationPoints << 32 - 3 % 32);
         param1.writeInt(this.eicDominationPoints << 16 % 32 | this.eicDominationPoints >>> 32 - 16 % 32);
         param1.writeInt(this.mmoDominationPoints >>> 7 % 32 | this.mmoDominationPoints << 32 - 7 % 32);
      }
   }
}

