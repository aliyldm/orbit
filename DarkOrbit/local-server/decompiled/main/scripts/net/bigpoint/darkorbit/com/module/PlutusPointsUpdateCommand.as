package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PlutusPointsUpdateCommand implements IModule
   {
      
      private static var _instance:PlutusPointsUpdateCommand;
      
      public var scoreEntriesList:Vector.<PlutusScoreEntryModule>;
      
      public var score:int = 0;
      
      public function PlutusPointsUpdateCommand(param1:int = 0, param2:Vector.<PlutusScoreEntryModule> = null)
      {
         super();
         if(param2 == null)
         {
            this.scoreEntriesList = new Vector.<PlutusScoreEntryModule>();
         }
         else
         {
            this.scoreEntriesList = param2;
         }
         this.score = param1;
      }
      
      public static function get instance() : PlutusPointsUpdateCommand
      {
         return _instance || (_instance = new PlutusPointsUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 19266;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:PlutusScoreEntryModule = null;
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
         this.score = param1.readInt();
         this.score = this.score >>> 14 % 32 | this.score << 32 - 14 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:PlutusScoreEntryModule = null;
         param1.writeShort(19266);
         param1.writeByte(this.scoreEntriesList.length);
         for each(_loc2_ in this.scoreEntriesList)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.score << 14 % 32 | this.score >>> 32 - 14 % 32);
      }
   }
}

