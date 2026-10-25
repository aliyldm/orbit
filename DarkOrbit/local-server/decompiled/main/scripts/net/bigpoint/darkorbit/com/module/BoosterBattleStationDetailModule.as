package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class BoosterBattleStationDetailModule extends BoosterDetailModule
   {
      
      private static var _instance:BoosterBattleStationDetailModule;
      
      public var percentage:Number = 0;
      
      public function BoosterBattleStationDetailModule(param1:String = "", param2:Number = 0)
      {
         super(param1);
         this.percentage = param2;
      }
      
      public static function get instance() : BoosterBattleStationDetailModule
      {
         return _instance || (_instance = new BoosterBattleStationDetailModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return 5769;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.percentage = param1.readFloat();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(5769);
         super.write(param1);
         param1.writeFloat(this.percentage);
      }
   }
}

