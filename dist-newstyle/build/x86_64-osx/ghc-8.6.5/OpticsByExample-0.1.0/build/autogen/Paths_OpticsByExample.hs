{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_OpticsByExample (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/jonathanlorimer/.cabal/bin"
libdir     = "/Users/jonathanlorimer/.cabal/lib/x86_64-osx-ghc-8.6.5/OpticsByExample-0.1.0-inplace"
dynlibdir  = "/Users/jonathanlorimer/.cabal/lib/x86_64-osx-ghc-8.6.5"
datadir    = "/Users/jonathanlorimer/.cabal/share/x86_64-osx-ghc-8.6.5/OpticsByExample-0.1.0"
libexecdir = "/Users/jonathanlorimer/.cabal/libexec/x86_64-osx-ghc-8.6.5/OpticsByExample-0.1.0"
sysconfdir = "/Users/jonathanlorimer/.cabal/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "OpticsByExample_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "OpticsByExample_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "OpticsByExample_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "OpticsByExample_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "OpticsByExample_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "OpticsByExample_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
