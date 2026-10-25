package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DisplayOfferCommand implements IModule
   {
      
      private static var _instance:DisplayOfferCommand;
      
      public var price:String = "";
      
      public var key:String = "";
      
      public var lootIds:Vector.<RewardModule>;
      
      public var closeable:Boolean = false;
      
      public var packageName:String = "";
      
      public var moveable:Boolean = false;
      
      public var alignment:AlignmentModule;
      
      public var link:String = "";
      
      public var percentage:int = 0;
      
      public function DisplayOfferCommand(param1:String = "", param2:String = "", param3:String = "", param4:String = "", param5:Vector.<RewardModule> = null, param6:int = 0, param7:AlignmentModule = null, param8:Boolean = false, param9:Boolean = false)
      {
         super();
         this.price = param4;
         this.key = param2;
         if(param5 == null)
         {
            this.lootIds = new Vector.<RewardModule>();
         }
         else
         {
            this.lootIds = param5;
         }
         this.closeable = param8;
         this.packageName = param1;
         this.moveable = param9;
         if(param7 == null)
         {
            this.alignment = new AlignmentModule();
         }
         else
         {
            this.alignment = param7;
         }
         this.link = param3;
         this.percentage = param6;
      }
      
      public static function get instance() : DisplayOfferCommand
      {
         return _instance || (_instance = new DisplayOfferCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -5491;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 18;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:RewardModule = null;
         this.price = param1.readUTF();
         this.key = param1.readUTF();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.lootIds.length > 0)
         {
            this.lootIds.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = RewardModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.lootIds.push(_loc4_);
            _loc2_++;
         }
         this.closeable = param1.readBoolean();
         this.packageName = param1.readUTF();
         this.moveable = param1.readBoolean();
         this.alignment = AlignmentModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.alignment)
         {
            this.alignment.read(param1);
         }
         this.link = param1.readUTF();
         this.percentage = param1.readInt();
         this.percentage = this.percentage << 9 % 32 | this.percentage >>> 32 - 9 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:RewardModule = null;
         param1.writeShort(-5491);
         param1.writeUTF(this.price);
         param1.writeUTF(this.key);
         param1.writeByte(this.lootIds.length);
         for each(_loc2_ in this.lootIds)
         {
            _loc2_.write(param1);
         }
         param1.writeBoolean(this.closeable);
         param1.writeUTF(this.packageName);
         param1.writeBoolean(this.moveable);
         if(null != this.alignment)
         {
            this.alignment.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeUTF(this.link);
         param1.writeInt(this.percentage >>> 9 % 32 | this.percentage << 32 - 9 % 32);
      }
   }
}

