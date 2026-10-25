package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MileageMarketInfoCommand implements IModule
   {
      
      private static var _instance:MileageMarketInfoCommand;
      
      public var coinCount:int = 0;
      
      public var exchangePackages:Vector.<MileageMarketPackageModule>;
      
      public var packageList:Vector.<String>;
      
      public var timeToEventEnd:Number = 0;
      
      public function MileageMarketInfoCommand(param1:Vector.<MileageMarketPackageModule> = null, param2:Vector.<String> = null, param3:int = 0, param4:Number = 0)
      {
         super();
         this.coinCount = param3;
         if(param1 == null)
         {
            this.exchangePackages = new Vector.<MileageMarketPackageModule>();
         }
         else
         {
            this.exchangePackages = param1;
         }
         if(param2 == null)
         {
            this.packageList = new Vector.<String>();
         }
         else
         {
            this.packageList = param2;
         }
         this.timeToEventEnd = param4;
      }
      
      public static function get instance() : MileageMarketInfoCommand
      {
         return _instance || (_instance = new MileageMarketInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 28789;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 20;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:MileageMarketPackageModule = null;
         this.coinCount = param1.readInt();
         this.coinCount = this.coinCount >>> 7 % 32 | this.coinCount << 32 - 7 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.exchangePackages.length > 0)
         {
            this.exchangePackages.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = MileageMarketPackageModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.exchangePackages.push(_loc4_);
            _loc2_++;
         }
         while(this.packageList.length > 0)
         {
            this.packageList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.packageList.push(param1.readUTF());
            _loc2_++;
         }
         this.timeToEventEnd = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:MileageMarketPackageModule = null;
         var _loc3_:String = null;
         param1.writeShort(28789);
         param1.writeInt(this.coinCount << 7 % 32 | this.coinCount >>> 32 - 7 % 32);
         param1.writeByte(this.exchangePackages.length);
         for each(_loc2_ in this.exchangePackages)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.packageList.length);
         for each(_loc3_ in this.packageList)
         {
            param1.writeUTF(_loc3_);
         }
         param1.writeDouble(this.timeToEventEnd);
      }
   }
}

