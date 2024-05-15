using StructuredGrid
import WriteVTK as WVTK

# create some surface (Z)
surface = zeros(3, 2, 4, 1)
surface[:, 1, 1, 1] = [0.0, 0.0, 0.0]
surface[:, 2, 1, 1] = [1.0, 0.0, 0.0]
surface[:, 1, 2, 1] = [0.0, 1.0, 0.0]
surface[:, 2, 2, 1] = [1.0, 1.0, 0.0]
surface[:, 1, 3, 1] = [0.0, 0.0, 1.0]
surface[:, 2, 3, 1] = [1.0, 0.0, 1.0]
surface[:, 1, 4, 1] = [0.0, 1.0, 1.0]
surface[:, 2, 4, 1] = [1.0, 1.0, 1.0]

# test surface functions
norms_face = normals_facial(surface)
normals_node = normals_nodal(surface)
mids_face = midpoints_facial(surface)

# scalar field
pressure_nodal = 200.0 * rand(1, 2, 3, 1)

# write paraview data
ascii = true
compress = false
WVTK.vtk_grid("surf_nodal", surface, ascii=ascii, compress=compress, append=false) do vtk
    vtk["Normals"] = normals_node
    vtk["Pressure"] = pressure_nodal
end
WVTK.vtk_grid("surf_facial", mids_face, ascii=ascii, compress=compress, append=false) do vtk
    vtk["Normals"] = norms_face
end