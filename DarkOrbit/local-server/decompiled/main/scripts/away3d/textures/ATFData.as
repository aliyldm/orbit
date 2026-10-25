package away3d.textures
{
   import flash.display3D.Context3DTextureFormat;
   import flash.utils.ByteArray;
   
   public class ATFData
   {
      
      public static const TYPE_NORMAL:int = 0;
      
      public static const TYPE_CUBE:int = 1;
      
      public var type:int;
      
      public var format:String;
      
      public var width:int;
      
      public var height:int;
      
      public var numTextures:int;
      
      public var data:ByteArray;
      
      public function ATFData(param1:ByteArray)
      {
         super();
         param1.position = 0;
         var _loc2_:String = param1.readUTFBytes(3);
         if(_loc2_ != "ATF")
         {
            throw new Error("ATF parsing error, unknown format " + _loc2_);
         }
         if(param1[6] == 255)
         {
            param1.position = 12;
         }
         else
         {
            param1.position = 6;
         }
         var _loc3_:uint = param1.readUnsignedByte();
         var _loc4_:int = _loc3_ >> 7;
         var _loc5_:int = _loc3_ & 0x7F;
         switch(_loc5_)
         {
            case 0:
            case 1:
               this.format = Context3DTextureFormat.BGRA;
               break;
            case 2:
            case 3:
               this.format = Context3DTextureFormat.COMPRESSED;
               break;
            case 4:
            case 5:
               this.format = "compressedAlpha";
               break;
            default:
               throw new Error("Invalid ATF format");
         }
         switch(_loc4_)
         {
            case 0:
               this.type = ATFData.TYPE_NORMAL;
               break;
            case 1:
               this.type = ATFData.TYPE_CUBE;
               break;
            default:
               throw new Error("Invalid ATF type");
         }
         this.width = Math.pow(2,param1.readUnsignedByte());
         this.height = Math.pow(2,param1.readUnsignedByte());
         this.numTextures = param1.readUnsignedByte();
         this.data = param1;
      }
   }
}

