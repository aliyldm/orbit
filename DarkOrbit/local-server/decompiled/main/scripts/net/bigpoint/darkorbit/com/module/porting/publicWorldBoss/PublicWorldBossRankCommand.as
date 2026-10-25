package net.bigpoint.darkorbit.com.module.porting.publicWorldBoss
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class PublicWorldBossRankCommand implements IModule
   {
      
      private static var _instance:PublicWorldBossRankCommand;
      
      public var ranklist:Vector.<PublicWorldBossRankReward>;
      
      public function PublicWorldBossRankCommand(param1:Vector.<PublicWorldBossRankReward> = null)
      {
         super();
         if(param1 == null)
         {
            this.ranklist = new Vector.<PublicWorldBossRankReward>();
         }
         else
         {
            this.ranklist = param1;
         }
      }
      
      public static function get instance() : PublicWorldBossRankCommand
      {
         return _instance || (_instance = new PublicWorldBossRankCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 8687;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:PublicWorldBossRankReward = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.ranklist.length > 0)
         {
            this.ranklist.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = PublicWorldBossRankReward(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.ranklist.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:PublicWorldBossRankReward = null;
         param1.writeShort(8687);
         param1.writeByte(this.ranklist.length);
         for each(_loc2_ in this.ranklist)
         {
            _loc2_.write(param1);
         }
      }
   }
}

