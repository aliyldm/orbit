package net.bigpoint.darkorbit.com.module.porting.captain
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class CaptainPerkCommand implements IModule
   {
      
      private static var _instance:CaptainPerkCommand;
      
      public var perkModifier:Number = 0;
      
      public var perkId:int = 0;
      
      public var perkTypeId:String = "";
      
      public var perkDrain:int = 0;
      
      public var levelMax:int = 0;
      
      public var upgradLevelList:Vector.<CaptainPerkUpgradLevelCommand>;
      
      public var level:int = 0;
      
      public function CaptainPerkCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:String = "", param5:Number = 0, param6:int = 0, param7:Vector.<CaptainPerkUpgradLevelCommand> = null)
      {
         super();
         this.perkModifier = param5;
         this.perkId = param1;
         this.perkTypeId = param4;
         this.perkDrain = param6;
         this.levelMax = param3;
         if(param7 == null)
         {
            this.upgradLevelList = new Vector.<CaptainPerkUpgradLevelCommand>();
         }
         else
         {
            this.upgradLevelList = param7;
         }
         this.level = param2;
      }
      
      public static function get instance() : CaptainPerkCommand
      {
         return _instance || (_instance = new CaptainPerkCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -11088;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 26;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:CaptainPerkUpgradLevelCommand = null;
         this.perkModifier = param1.readFloat();
         this.perkId = param1.readInt();
         this.perkId = this.perkId >>> 16 % 32 | this.perkId << 32 - 16 % 32;
         this.perkTypeId = param1.readUTF();
         this.perkDrain = param1.readInt();
         this.perkDrain = this.perkDrain << 5 % 32 | this.perkDrain >>> 32 - 5 % 32;
         this.levelMax = param1.readInt();
         this.levelMax = this.levelMax << 6 % 32 | this.levelMax >>> 32 - 6 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.upgradLevelList.length > 0)
         {
            this.upgradLevelList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = CaptainPerkUpgradLevelCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.upgradLevelList.push(_loc4_);
            _loc2_++;
         }
         this.level = param1.readInt();
         this.level = this.level >>> 12 % 32 | this.level << 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:CaptainPerkUpgradLevelCommand = null;
         param1.writeShort(-11088);
         param1.writeFloat(this.perkModifier);
         param1.writeInt(this.perkId << 16 % 32 | this.perkId >>> 32 - 16 % 32);
         param1.writeUTF(this.perkTypeId);
         param1.writeInt(this.perkDrain >>> 5 % 32 | this.perkDrain << 32 - 5 % 32);
         param1.writeInt(this.levelMax >>> 6 % 32 | this.levelMax << 32 - 6 % 32);
         param1.writeByte(this.upgradLevelList.length);
         for each(_loc2_ in this.upgradLevelList)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.level << 12 % 32 | this.level >>> 32 - 12 % 32);
      }
   }
}

