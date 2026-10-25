package net.bigpoint.darkorbit.com.module.porting.achievement
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class AchievementListCommand implements IModule
   {
      
      private static var _instance:AchievementListCommand;
      
      public var unlockAchievements2:Vector.<AchievementInfoCommand>;
      
      public var nextAchievements:Vector.<AchievementInfoCommand>;
      
      public var displayTitleId:int = 0;
      
      public var titleCommandList:Vector.<AchievementTitleCommand>;
      
      public var list:Vector.<AchievementInfoCommand>;
      
      public var unlockAchievements1:Vector.<AchievementInfoCommand>;
      
      public function AchievementListCommand(param1:Vector.<AchievementInfoCommand> = null, param2:Vector.<AchievementTitleCommand> = null, param3:int = 0, param4:Vector.<AchievementInfoCommand> = null, param5:Vector.<AchievementInfoCommand> = null, param6:Vector.<AchievementInfoCommand> = null)
      {
         super();
         if(param6 == null)
         {
            this.unlockAchievements2 = new Vector.<AchievementInfoCommand>();
         }
         else
         {
            this.unlockAchievements2 = param6;
         }
         if(param4 == null)
         {
            this.nextAchievements = new Vector.<AchievementInfoCommand>();
         }
         else
         {
            this.nextAchievements = param4;
         }
         this.displayTitleId = param3;
         if(param2 == null)
         {
            this.titleCommandList = new Vector.<AchievementTitleCommand>();
         }
         else
         {
            this.titleCommandList = param2;
         }
         if(param1 == null)
         {
            this.list = new Vector.<AchievementInfoCommand>();
         }
         else
         {
            this.list = param1;
         }
         if(param5 == null)
         {
            this.unlockAchievements1 = new Vector.<AchievementInfoCommand>();
         }
         else
         {
            this.unlockAchievements1 = param5;
         }
      }
      
      public static function get instance() : AchievementListCommand
      {
         return _instance || (_instance = new AchievementListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 16014;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 24;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:AchievementInfoCommand = null;
         var _loc5_:AchievementInfoCommand = null;
         var _loc6_:AchievementTitleCommand = null;
         var _loc7_:AchievementInfoCommand = null;
         var _loc8_:AchievementInfoCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.unlockAchievements2.length > 0)
         {
            this.unlockAchievements2.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = AchievementInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.unlockAchievements2.push(_loc4_);
            _loc2_++;
         }
         while(this.nextAchievements.length > 0)
         {
            this.nextAchievements.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = AchievementInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.nextAchievements.push(_loc5_);
            _loc2_++;
         }
         this.displayTitleId = param1.readInt();
         this.displayTitleId = this.displayTitleId << 15 % 32 | this.displayTitleId >>> 32 - 15 % 32;
         while(this.titleCommandList.length > 0)
         {
            this.titleCommandList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc6_ = AchievementTitleCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc6_.read(param1);
            this.titleCommandList.push(_loc6_);
            _loc2_++;
         }
         while(this.list.length > 0)
         {
            this.list.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc7_ = AchievementInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc7_.read(param1);
            this.list.push(_loc7_);
            _loc2_++;
         }
         while(this.unlockAchievements1.length > 0)
         {
            this.unlockAchievements1.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc8_ = AchievementInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc8_.read(param1);
            this.unlockAchievements1.push(_loc8_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:AchievementInfoCommand = null;
         var _loc3_:AchievementInfoCommand = null;
         var _loc4_:AchievementTitleCommand = null;
         var _loc5_:AchievementInfoCommand = null;
         var _loc6_:AchievementInfoCommand = null;
         param1.writeShort(16014);
         param1.writeByte(this.unlockAchievements2.length);
         for each(_loc2_ in this.unlockAchievements2)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.nextAchievements.length);
         for each(_loc3_ in this.nextAchievements)
         {
            _loc3_.write(param1);
         }
         param1.writeInt(this.displayTitleId >>> 15 % 32 | this.displayTitleId << 32 - 15 % 32);
         param1.writeByte(this.titleCommandList.length);
         for each(_loc4_ in this.titleCommandList)
         {
            _loc4_.write(param1);
         }
         param1.writeByte(this.list.length);
         for each(_loc5_ in this.list)
         {
            _loc5_.write(param1);
         }
         param1.writeByte(this.unlockAchievements1.length);
         for each(_loc6_ in this.unlockAchievements1)
         {
            _loc6_.write(param1);
         }
      }
   }
}

