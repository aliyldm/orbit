package net.bigpoint.darkorbit.com.module.porting.captain
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class CaptainCommand implements IModule
   {
      
      private static var _instance:CaptainCommand;
      
      public var sellingPrice:int = 0;
      
      public var isSelected:Boolean = false;
      
      public var sellItemObtained:String = "";
      
      public var captainTypeId:String = "";
      
      public var captainName:String = "";
      
      public var perkList:Vector.<CaptainPerkCommand>;
      
      public var maxEnergy:int = 0;
      
      public var captainId:int = 0;
      
      public var captainEnergy:int = 0;
      
      public function CaptainCommand(param1:int = 0, param2:String = "", param3:String = "", param4:int = 0, param5:String = "", param6:int = 0, param7:int = 0, param8:Boolean = false, param9:Vector.<CaptainPerkCommand> = null)
      {
         super();
         this.sellingPrice = param4;
         this.isSelected = param8;
         this.sellItemObtained = param5;
         this.captainTypeId = param3;
         this.captainName = param2;
         if(param9 == null)
         {
            this.perkList = new Vector.<CaptainPerkCommand>();
         }
         else
         {
            this.perkList = param9;
         }
         this.maxEnergy = param7;
         this.captainId = param1;
         this.captainEnergy = param6;
      }
      
      public static function get instance() : CaptainCommand
      {
         return _instance || (_instance = new CaptainCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -13966;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 27;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:CaptainPerkCommand = null;
         this.sellingPrice = param1.readInt();
         this.sellingPrice = this.sellingPrice << 16 % 32 | this.sellingPrice >>> 32 - 16 % 32;
         this.isSelected = param1.readBoolean();
         this.sellItemObtained = param1.readUTF();
         this.captainTypeId = param1.readUTF();
         this.captainName = param1.readUTF();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.perkList.length > 0)
         {
            this.perkList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = CaptainPerkCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.perkList.push(_loc4_);
            _loc2_++;
         }
         this.maxEnergy = param1.readInt();
         this.maxEnergy = this.maxEnergy << 10 % 32 | this.maxEnergy >>> 32 - 10 % 32;
         this.captainId = param1.readInt();
         this.captainId = this.captainId << 5 % 32 | this.captainId >>> 32 - 5 % 32;
         this.captainEnergy = param1.readInt();
         this.captainEnergy = this.captainEnergy >>> 16 % 32 | this.captainEnergy << 32 - 16 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:CaptainPerkCommand = null;
         param1.writeShort(-13966);
         param1.writeInt(this.sellingPrice >>> 16 % 32 | this.sellingPrice << 32 - 16 % 32);
         param1.writeBoolean(this.isSelected);
         param1.writeUTF(this.sellItemObtained);
         param1.writeUTF(this.captainTypeId);
         param1.writeUTF(this.captainName);
         param1.writeByte(this.perkList.length);
         for each(_loc2_ in this.perkList)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.maxEnergy >>> 10 % 32 | this.maxEnergy << 32 - 10 % 32);
         param1.writeInt(this.captainId >>> 5 % 32 | this.captainId << 32 - 5 % 32);
         param1.writeInt(this.captainEnergy << 16 % 32 | this.captainEnergy >>> 32 - 16 % 32);
      }
   }
}

