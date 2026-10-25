package net.bigpoint.darkorbit.com.module.porting.captain
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class CaptainPerkUpgradLevelCommand implements IModule
   {
      
      private static var _instance:CaptainPerkUpgradLevelCommand;
      
      public var modifier:Number = 0;
      
      public var upgradeLevel:int = 0;
      
      public var costList:Vector.<CaptainPerkUpgradLevelCostCommand>;
      
      public function CaptainPerkUpgradLevelCommand(param1:int = 0, param2:Number = 0, param3:Vector.<CaptainPerkUpgradLevelCostCommand> = null)
      {
         super();
         this.modifier = param2;
         this.upgradeLevel = param1;
         if(param3 == null)
         {
            this.costList = new Vector.<CaptainPerkUpgradLevelCostCommand>();
         }
         else
         {
            this.costList = param3;
         }
      }
      
      public static function get instance() : CaptainPerkUpgradLevelCommand
      {
         return _instance || (_instance = new CaptainPerkUpgradLevelCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -13770;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:CaptainPerkUpgradLevelCostCommand = null;
         this.modifier = param1.readFloat();
         this.upgradeLevel = param1.readInt();
         this.upgradeLevel = this.upgradeLevel << 11 % 32 | this.upgradeLevel >>> 32 - 11 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.costList.length > 0)
         {
            this.costList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = CaptainPerkUpgradLevelCostCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.costList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:CaptainPerkUpgradLevelCostCommand = null;
         param1.writeShort(-13770);
         param1.writeFloat(this.modifier);
         param1.writeInt(this.upgradeLevel >>> 11 % 32 | this.upgradeLevel << 32 - 11 % 32);
         param1.writeByte(this.costList.length);
         for each(_loc2_ in this.costList)
         {
            _loc2_.write(param1);
         }
      }
   }
}

