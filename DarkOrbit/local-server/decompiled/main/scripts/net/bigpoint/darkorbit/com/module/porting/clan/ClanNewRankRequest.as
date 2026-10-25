package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanNewRankRequest implements IModule
   {
      
      private static var _instance:ClanNewRankRequest;
      
      public var newRank:String = "";
      
      public function ClanNewRankRequest(param1:String = "")
      {
         super();
         this.newRank = param1;
      }
      
      public static function get instance() : ClanNewRankRequest
      {
         return _instance || (_instance = new ClanNewRankRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -11351;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.newRank = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-11351);
         param1.writeUTF(this.newRank);
      }
   }
}

