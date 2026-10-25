package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CompanyHierarchyRankingModule implements IModule
   {
      
      private static var _instance:CompanyHierarchyRankingModule;
      
      public var clanId:int = 0;
      
      public var rank:int = 0;
      
      public var clanName:String = "";
      
      public var leaderName:String = "";
      
      public var cbsNamesAndLocations:String = "";
      
      public var rankingPoints:int = 0;
      
      public function CompanyHierarchyRankingModule(param1:int = 0, param2:int = 0, param3:String = "", param4:String = "", param5:String = "", param6:int = 0)
      {
         super();
         this.clanId = param1;
         this.rank = param2;
         this.clanName = param3;
         this.leaderName = param4;
         this.cbsNamesAndLocations = param5;
         this.rankingPoints = param6;
      }
      
      public static function get instance() : CompanyHierarchyRankingModule
      {
         return _instance || (_instance = new CompanyHierarchyRankingModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6008;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 18;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.clanId = param1.readInt();
         this.clanId = this.clanId << 15 % 32 | this.clanId >>> 32 - 15 % 32;
         this.rank = param1.readInt();
         this.rank = this.rank << 10 % 32 | this.rank >>> 32 - 10 % 32;
         this.clanName = param1.readUTF();
         this.leaderName = param1.readUTF();
         this.cbsNamesAndLocations = param1.readUTF();
         this.rankingPoints = param1.readInt();
         this.rankingPoints = this.rankingPoints >>> 4 % 32 | this.rankingPoints << 32 - 4 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6008);
         param1.writeInt(this.clanId >>> 15 % 32 | this.clanId << 32 - 15 % 32);
         param1.writeInt(this.rank >>> 10 % 32 | this.rank << 32 - 10 % 32);
         param1.writeUTF(this.clanName);
         param1.writeUTF(this.leaderName);
         param1.writeUTF(this.cbsNamesAndLocations);
         param1.writeInt(this.rankingPoints << 4 % 32 | this.rankingPoints >>> 32 - 4 % 32);
      }
   }
}

