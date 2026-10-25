package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class EditClanRanksRequest implements IModule
   {
      
      private static var _instance:EditClanRanksRequest;
      
      public var ranks:Vector.<ClanRankInfoCommand>;
      
      public function EditClanRanksRequest(param1:Vector.<ClanRankInfoCommand> = null)
      {
         super();
         if(param1 == null)
         {
            this.ranks = new Vector.<ClanRankInfoCommand>();
         }
         else
         {
            this.ranks = param1;
         }
      }
      
      public static function get instance() : EditClanRanksRequest
      {
         return _instance || (_instance = new EditClanRanksRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6844;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ClanRankInfoCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.ranks.length > 0)
         {
            this.ranks.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ClanRankInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.ranks.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:ClanRankInfoCommand = null;
         param1.writeShort(6844);
         param1.writeByte(this.ranks.length);
         for each(_loc2_ in this.ranks)
         {
            _loc2_.write(param1);
         }
      }
   }
}

