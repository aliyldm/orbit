package net.bigpoint.darkorbit.com.module.porting.expedition
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ExpeditionRankUserInfoCommand implements IModule
   {
      
      private static var _instance:ExpeditionRankUserInfoCommand;
      
      public var rank:int = 0;
      
      public var curLevel:int = 0;
      
      public var clearanceTime:int = 0;
      
      public var userId:int = 0;
      
      public var userName:String = "";
      
      public function ExpeditionRankUserInfoCommand(param1:int = 0, param2:String = "", param3:int = 0, param4:int = 0, param5:int = 0)
      {
         super();
         this.rank = param4;
         this.curLevel = param3;
         this.clearanceTime = param5;
         this.userId = param1;
         this.userName = param2;
      }
      
      public static function get instance() : ExpeditionRankUserInfoCommand
      {
         return _instance || (_instance = new ExpeditionRankUserInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -12941;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 18;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.rank = param1.readInt();
         this.rank = this.rank >>> 4 % 32 | this.rank << 32 - 4 % 32;
         this.curLevel = param1.readInt();
         this.curLevel = this.curLevel << 13 % 32 | this.curLevel >>> 32 - 13 % 32;
         this.clearanceTime = param1.readInt();
         this.clearanceTime = this.clearanceTime >>> 9 % 32 | this.clearanceTime << 32 - 9 % 32;
         this.userId = param1.readInt();
         this.userId = this.userId >>> 14 % 32 | this.userId << 32 - 14 % 32;
         this.userName = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-12941);
         param1.writeInt(this.rank << 4 % 32 | this.rank >>> 32 - 4 % 32);
         param1.writeInt(this.curLevel >>> 13 % 32 | this.curLevel << 32 - 13 % 32);
         param1.writeInt(this.clearanceTime << 9 % 32 | this.clearanceTime >>> 32 - 9 % 32);
         param1.writeInt(this.userId << 14 % 32 | this.userId >>> 32 - 14 % 32);
         param1.writeUTF(this.userName);
      }
   }
}

