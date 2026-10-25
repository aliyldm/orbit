package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PlutusInfoCommand implements IModule
   {
      
      private static var _instance:PlutusInfoCommand;
      
      public var playerPoints:int = 0;
      
      public var scoreEntriesList:Vector.<PlutusScoreEntryModule>;
      
      public var status:PlutusStatusCommand;
      
      public var playerRanges:Vector.<RankRewardRangeModule>;
      
      public var filename:String = "";
      
      public function PlutusInfoCommand(param1:PlutusStatusCommand = null, param2:int = 0, param3:Vector.<PlutusScoreEntryModule> = null, param4:String = "", param5:Vector.<RankRewardRangeModule> = null)
      {
         super();
         this.playerPoints = param2;
         if(param3 == null)
         {
            this.scoreEntriesList = new Vector.<PlutusScoreEntryModule>();
         }
         else
         {
            this.scoreEntriesList = param3;
         }
         if(param1 == null)
         {
            this.status = new PlutusStatusCommand();
         }
         else
         {
            this.status = param1;
         }
         if(param5 == null)
         {
            this.playerRanges = new Vector.<RankRewardRangeModule>();
         }
         else
         {
            this.playerRanges = param5;
         }
         this.filename = param4;
      }
      
      public static function get instance() : PlutusInfoCommand
      {
         return _instance || (_instance = new PlutusInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -28603;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 14;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:PlutusScoreEntryModule = null;
         var _loc5_:RankRewardRangeModule = null;
         this.playerPoints = param1.readInt();
         this.playerPoints = this.playerPoints >>> 1 % 32 | this.playerPoints << 32 - 1 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.scoreEntriesList.length > 0)
         {
            this.scoreEntriesList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = PlutusScoreEntryModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.scoreEntriesList.push(_loc4_);
            _loc2_++;
         }
         this.status = PlutusStatusCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.status)
         {
            this.status.read(param1);
         }
         while(this.playerRanges.length > 0)
         {
            this.playerRanges.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = RankRewardRangeModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.playerRanges.push(_loc5_);
            _loc2_++;
         }
         this.filename = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:PlutusScoreEntryModule = null;
         var _loc3_:RankRewardRangeModule = null;
         param1.writeShort(-28603);
         param1.writeInt(this.playerPoints << 1 % 32 | this.playerPoints >>> 32 - 1 % 32);
         param1.writeByte(this.scoreEntriesList.length);
         for each(_loc2_ in this.scoreEntriesList)
         {
            _loc2_.write(param1);
         }
         if(null != this.status)
         {
            this.status.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeByte(this.playerRanges.length);
         for each(_loc3_ in this.playerRanges)
         {
            _loc3_.write(param1);
         }
         param1.writeUTF(this.filename);
      }
   }
}

