# StaticFile modified
#
# This plugin changes modified check policy of StaticFile#write.
#
# before:
#   * caches the modified time to @@mtimes after first write
#
# after
#   * compares mtime of src file and dst file

module Jekyll
  #class StaticFile
  #  # Is source path modified?
  #  #
  #  # Returns true if modified since last write.
  #  def modified?(dest_path)
  #    File.stat(dest_path).mtime.to_i < mtime
  #  end

  #  # Write the static file to the destination directory (if modified).
  #  #
  #  # dest - The String path to the destination dir.
  #  #
  #  # Returns false if the file was not modified since last time (no-op).
  #  def write(dest)
  #    dest_path = destination(dest)

  #    return false if File.exist?(dest_path) and !modified?(dest_path)
  #    @@mtimes[path] = mtime

  #    FileUtils.mkdir_p(File.dirname(dest_path))
  #    FileUtils.cp(path, dest_path)

  #    true
  #  end
  #end
end
