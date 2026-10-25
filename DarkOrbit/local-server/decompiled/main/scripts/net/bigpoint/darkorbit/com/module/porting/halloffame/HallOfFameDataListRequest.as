package net.bigpoint.darkorbit.com.module.porting.halloffame
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HallOfFameDataListRequest implements IModule
   {
      
      private static var _instance:HallOfFameDataListRequest;
      
      public static const HALLOFFAMETYPE_GalacticStrife_repRanking:int = 0;
      
      public static const HALLOFFAMETYPE_GalacticStrife_repPerKillRanking:int = 1;
      
      public static const HALLOFFAMETYPE_FrozenLabyrinth:int = 2;
      
      public static const HALLOFFAMETYPE_EternalGate:int = 3;
      
      public static const HALLOFFAMETYPE_MimesisMutiny:int = 4;
      
      public static const HALLOFFAMETYPE_PayloadEscort:int = 5;
      
      public static const HALLOFFAMETYPE_PublicWorldBoss:int = 6;
      
      public static const HALLOFFAMETYPE__MAX:int = 7;
      
      public var requested:int = 0;
      
      public function HallOfFameDataListRequest(param1:int = 0)
      {
         super();
         this.requested = param1;
      }
      
      public static function get instance() : HallOfFameDataListRequest
      {
         return _instance || (_instance = new HallOfFameDataListRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -29656;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.requested = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-29656);
         param1.writeShort(this.requested);
      }
   }
}

